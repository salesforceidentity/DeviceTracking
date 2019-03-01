public with sharing class DeviceTrackingLoginFlowController
{
    public string lhid {get; set;}  // login history id
    public DeviceWrapper current_device {get; set;}
    public boolean isApprovalPending  {get; set;}
    
    public DeviceWrapper getDevice() 
    {
        getDeviceInfo();
        
        return current_device;
    }
    
    public DeviceTrackingLoginFlowController()
    {
        current_device = null;
        isApprovalPending = true;  
        
        getDeviceInfo();
    }
    
    public PageReference finishFlow() {
       
        if (isApprovalPending == true)
            return new PageReference('/secur/logout.jsp');
        
        Auth.SessionManagement.FinishLoginFlow();
       
        return new PageReference('/');
    }


    void getDeviceInfo() 
    {
        lhid = Auth.SessionManagement.getCurrentSession().get('LoginHistoryId');
        
        if (lhid == null)
            return;
        
        // Get device info for the current user's session
        List<UserDevice> devices = [SELECT BrowserType,CreatedDate,DeviceNativeUid,DeviceType,Id,PlatformType,Status,UserLastSeen, LastLoginHistoryId, User.Name, User.Username FROM UserDevice WHERE LastLoginHistoryId=:lhid];
        
        
        if(devices.isEmpty() == true || devices == null)
            return;
        
        current_device = new DeviceWrapper(devices[0]);
        
        // Check if the device is pending for approval
        List<approved_device__C> approved_devices = [SELECT id,status__c from approved_device__C WHERE name=:devices[0].id];
        
        if(approved_devices.isEmpty() == true)
        {
            isApprovalPending = true;
            current_device.status = 'New';
            return;
        }
        
        if(approved_devices[0].status__c == 'Approved')
        {
            isApprovalPending = false;
            current_device.status = 'Approved';
        }
        else {
            isApprovalPending = true;
            current_device.status = 'Revoked';
        }
    }
    
    void getApplicationInfo()
    {
        List<UserDeviceApplication> user_device_apps = [SELECT ApplicationType,Id,IsDeleted,Name,Status,UserDeviceId,UserId FROM UserDeviceApplication];
    }
}
