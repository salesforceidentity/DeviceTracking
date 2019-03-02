public class DeviceWrapper {
    public String id{get; set;}
    public String userId{get; set;}
    public String userName{get; set;}
    public String userUsername{get; set;}
    public String deviceType{get; set;}
    public String platformType{get; set;}
    public String status{get; set;}
    public String deviceNativeUid{get; set;}
    public String UserLastSeen{get; set;}
    public String LoginHistoryId {get; set;}
    public String BrowserType {get; set;}

    public DeviceWrapper()
    {
    
    }
    
    public DeviceWrapper(UserDevice d)
    {
        this.id = d.Id;
        this.LoginHistoryId = d.LastLoginHistoryId;
        this.userName = d.User.Name;
        this.userUsername = d.User.Username;
        this.deviceType = d.deviceType;
        this.platformType = d.platformType;
        this.status = d.status;
        this.deviceNativeUid = d.deviceNativeUid;
        this.UserLastSeen = d.UserLastSeen.format('yyyy-MM-dd HH:mm:ss', 'PST');
        this.BrowserType = d.BrowserType;
        
        String device_type;
        String device_version;
        
        if(d.BrowserType != null) 
        { 
            device_type = d.BrowserType.substring(0,2);
            device_version = d.BrowserType.substring(3, 5);
        }
        
        
        if (device_type == '10')
            this.BrowserType = 'IE ' + device_version;
        
        else if (device_type == '11')
            this.BrowserType = 'FIREFOX ' + device_version;
            
        if (device_type == '13')
            this.BrowserType = 'CHROME ' + device_version;
        
        else if (device_type == '14')
            this.BrowserType = 'SAFARI ' + device_version;
        
        else if (device_type == '15')
            this.BrowserType = 'OPERA';
            
        else if (device_type == '16')
            this.BrowserType = 'ANDROID';
            
        else if (device_type == '17')
            this.BrowserType = 'NETSCAPE';
        
        else if (device_type == '18')
            this.BrowserType = 'OTHER_WEBKIT';
            
        else if (device_type == '19')
            this.BrowserType = 'OTHER_GECKO';
            
        else if (device_type == '20')
            this.BrowserType = 'OTHER_KHTML';
        
        else if (device_type == '21')
            this.BrowserType = 'OTHER_MOBILE';
            
        else if (device_type == '22')
            this.BrowserType = 'SALESFORCE_DESKTOP';
        
        else if (device_type == '23')
            this.BrowserType = 'BLACKBERRY';
        
        else if (device_type == '24')
            this.BrowserType = 'GOOD_ACCESS';
            
        else if (device_type == '25')
            this.BrowserType = 'EDGE';
            
        else if (device_type == '26')
            this.BrowserType = 'SALESFORCE_MOBILE';
       
    }
}
