public class MALayerSearchComponentHelper {
    
    @RemoteAction
    public static list<sma__MASavedQry__c> getLayers(String searchTerm, String types) {

        List<String> typesList = types.split(',');
        //List<sma__MASavedQry__c> filteredLayers = new List<sma__MASavedQry__c>();
        List<sma__MASavedQry__c> allLayers = [SELECT Id, Name, CreatedDate, sma__AdvancedOptions__c, sma__BaseObject__r.sma__Type__c, sma__OrgWide__c, 
                                                sma__Folder__c, sma__Folder__r.Name, sma__Folder__r.sma__User__c, sma__Folder__r.sma__ParentFolder__c, sma__Folder__r.sma__ParentFolder__r.Name,
                                                (SELECT Id, sma__Value__c, sma__Type__c from sma__Saved_Query_Components__r) 
                                                FROM sma__MASavedQry__c 
                                                WHERE Name LIKE :searchTerm + '%' AND sma__BaseObject__r.sma__Type__c IN :typesList ORDER BY name];
        /*for(sma__MASavedQry__c layer: allLayers) {
            if(layer.sma__BaseObject__r.sma__Type__c.equalsIgnoreCase('live')) {
                if(layer.sma__Saved_Query_Components__r != null && !layer.sma__Saved_Query_Components__r.isEmpty() && layer.sma__Saved_Query_Components__r[0].sma__Type__c.equalsIgnoreCase('DeviceLayerVendor')) {
                    filteredLayers.add(layer);
                }
            }
            else {
                filteredLayers.add(layer);
            }
        }*/
        return allLayers;
    }
    
    @RemoteAction
    public static sma__MASavedQry__c getLayer(String layerid) {

        for (sma__MASavedQry__c MASavedQry : [SELECT Id, Name, sma__AdvancedOptions__c, (SELECT Id, sma__Value__c, sma__Type__c from sma__Saved_Query_Components__r) FROM sma__MASavedQry__c WHERE Id = :layerid]) {
            return MASavedQry;
        }
        
        return null;

    }

    @RemoteAction
    public static Map<String, Object> getFolders() {
        System.debug(loggingLevel.Error, '*** getFolders ***');
        Map<String, Object> folderIds = new Map<String, Object>();
        for(sma__MAFolder__c fold : [SELECT Id, Name, sma__ParentFolder__c FROM sma__MAFolder__c]) {
            folderIds.put((String)fold.Id, (Object)fold);
        }
        System.debug(loggingLevel.Error, '*** folderIds: ' + folderIds);
        return folderIds;
    }

    /*public static string GetFullFolderPath(string layerId) {
       // System.debug('GetFullFolderPath called');
       set<string> layerIds = new set<string>();
       Map<string, MAFolder__c> folderIds = new Map<string, MAFolder__c>();
       layerIds.add(layerId);
       
       //FIND THE LAYER!
       boolean isCorp = false;
       string initialFolderId = '';
       string prevFolderId = '';
       string currFolderId = '';
       string folderPath = '';
       
       
       for( MAFolder__c MAFolder : database.query('SELECT Id, Name, ParentFolder__c FROM MAFolder__c')) {
           folderIds.put(MAFolder.Id, MAFolder);
       }
       
       
       for( MASavedQry__c MALayer : database.query('SELECT Folder__c, Folder__r.Name, OrgWide__c FROM MASavedQry__c WHERE Id IN :layerIds LIMIT 1') ) {
           isCorp = MALayer.OrgWide__c;
           initialFolderId = MALayer.Folder__c;
       }
       for ( MALayer__c MALayer : database.query('SELECT Folder__c, Folder__r.Name, User__c FROM MALayer__c WHERE Id IN :layerIds LIMIT 1') ) {
           isCorp = MALayer.User__c == null;
           initialFolderId = MALayer.Folder__c;
       }
       for ( MALocation__c MALayer : database.query('SELECT MapAnythingFolder__c, MapAnythingFolder__r.Name, User__c FROM MALocation__c WHERE Id IN :layerIds LIMIT 1') ) {
           isCorp = MALayer.User__c == null;
           initialFolderId = MALayer.MapAnythingFolder__c;
       }
       for ( MATerritory__c MALayer : database.query('SELECT Folder__c, Folder__r.Name, User__c FROM MATerritory__c WHERE Id IN :layerIds LIMIT 1') ) {
           isCorp = MALayer.User__c == null;
           initialFolderId = MALayer.Folder__c;
       }
       for ( MAFolder__c MALayer : database.query('SELECT ParentFolder__c, ParentFolder__r.Name, User__c FROM MAFolder__c WHERE Id IN :layerIds LIMIT 1') ) {
           isCorp = MALayer.User__c == null;
           initialFolderId = MALayer.ParentFolder__c;
       }
       
       prevFolderId = initialFolderId;
       currFolderId = initialFolderId;
       
       while(currFolderId != null) {
           MAFolder__c currFolder = folderIds.get(currFolderId);
           folderPath = currFolder.Name + ' > ' + folderPath;
           currFolderId = currFolder.ParentFolder__c;
       }
       
       folderPath = isCorp ? Label.MA_Corporate + ' > ' + folderPath : Label.MA_Personal + ' > ' + folderPath;
       
       return folderPath.removeEnd(' > ');
   }*/


    
}
