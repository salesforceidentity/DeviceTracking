public class DeviceController {
    private List<DeviceWrapper> devices;     
    private List<DeviceWrapper> adevices;
    public String targetId{get;set;}  
    public String targetToken{get;set;}
 
    public String debug;

    public DeviceController() {
        targetId = '';
        devices = new List<DeviceWrapper>();
        adevices = new List<DeviceWrapper>();
        
        init();
    }
    
    public void init()
    {
        List<UserDevice> rawDevices = [SELECT BrowserType,CreatedDate,DeviceNativeUid,DeviceType,Id,PlatformType,Status,UserLastSeen,LastLoginHistoryId,User.Name, User.Username FROM UserDevice order by CreatedDate];
        
        devices.clear();
        adevices.clear();
        
        try{
            for(UserDevice d:rawDevices) {
                DeviceWrapper a = new DeviceWrapper(d);
                
                List<approved_device__C> approved_device = [SELECT id, status__c from approved_device__C where name = :d.id LIMIT 1];
                
                if (approved_device.isEmpty())
                {
                    a.status = 'New';
                    adevices.add(a);  
                }
                else if (approved_device[0].status__c == '' || approved_device[0].status__c == null)
                {
                    a.Status = 'New';
                    adevices.add(a);     
                }
                
                else if (approved_device[0].status__c == 'New' || approved_device[0].status__c == 'Revoked')
                {
                    a.Status = 'Revoked';
                    adevices.add(a);   
                }     
                else if (approved_device[0].status__c == 'Approved')
                {
                    a.Status = 'Approved';
                    devices.add(a);   
                } 
            }
            
        }catch(Exception e){
            debug = 'Exception: ' + e;
            system.debug('Exception! Failed with error: '+e);
            for(UserDevice d:rawDevices) {
                if(d.DeviceType != 'Desktop' && d.Status != 'Revoked'){
                    DeviceWrapper c = new DeviceWrapper(d);
                    adevices.add(c);  
                }else{
                    DeviceWrapper c = new DeviceWrapper(d);
                    devices.add(c);    
                }
            }
        }     
    }
    
    public List<DeviceWrapper> getDevice() {
        debug = 'get devices';
      
        return devices;
    }
    
    public List<DeviceWrapper> getAdevice() {
        debug = 'get approved devices';
        
        return adevices;
    }
    
    public PageReference getAllDevices() {
        
        return null;
    } 
    
   
    public void revoke() {
    
        approved_device__c approved_device = null;
        
        List<UserDevice> devices = [SELECT id, deviceType, DeviceNativeUid, status from UserDevice where id = :targetId LIMIT 1];

        if(devices.isEmpty() == true)
            return;
            
        // Update the approved devices list   
        try {
            approved_device = [Select id from approved_device__c where name = :targetId LIMIT 1];
            approved_device.status__c = 'Revoked';
            update approved_device;
            
            // Refresh the list of devices
            init();
        }
        catch(Exception e) 
        {
            approved_device__c device = new approved_device__c();
            device.name = targetId;
            device.status__c = 'Revoked';
            insert device;
            
            // Refresh the list of devices
            init();
            
            return;
        }
                      
        // In case of mobile app revoke the device+token
        if(devices[0].DeviceNativeUid != null)
        {
            string user = userinfo.getName();
            string token = userinfo.GetSessionID();
            system.debug('Token value sent:'+encodingutil.urlencode(token,'UTF-8'));
            RevokingDevice.makeCallout(user,token,targetId);
            
            // refresh the list of devices
            init();
            
            return;
        }
    }    
    
    public void approve() {
        approved_device__c approved_device = null;
               
        try {
            approved_device = [Select id from approved_device__c where name = :targetId LIMIT 1];
            approved_device.status__c = 'Approved';
            update approved_device;
            
            // Refresh the list of devices
            init();
        }
        catch(Exception e) 
        {
            approved_device__c device = new approved_device__c();
            device.name = targetId;
            device.status__c = 'Approved';
            insert device;
            
            // Refresh the list of devices
            init();
            
            return;
        }
    }
    
    public Component.Apex.OutputPanel getTheDebugPanel() {
        Component.Apex.OutputPanel outPanel = new Component.Apex.OutputPanel();
        Component.Apex.outputLabel debugLabel = new Component.Apex.outputLabel();
        
        debugLabel.value = debug;
        
        outPanel.childComponents.add(debugLabel);
       
        return outPanel;
    }
}
