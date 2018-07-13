public class MALayerSearchComponentHelper {
    
    @RemoteAction
    public static list<sma__MASavedQry__c> getLayers(String searchTerm, String types) {

        /*
        List<String> typesList = types.split(',');
        List<sma__MASavedQry__c> allLayers = [SELECT Id, Name, CreatedDate, sma__AdvancedOptions__c, sma__BaseObject__r.sma__Type__c, sma__OrgWide__c, 
                                                sma__Folder__c, sma__Folder__r.Name, sma__Folder__r.sma__User__c, sma__Folder__r.sma__ParentFolder__c, sma__Folder__r.sma__ParentFolder__r.Name,
                                                (SELECT Id, sma__Value__c, sma__Type__c from sma__Saved_Query_Components__r) 
                                                FROM sma__MASavedQry__c 
                                                WHERE Name LIKE :searchTerm + '%' AND sma__BaseObject__r.sma__Type__c IN :typesList ORDER BY name];
        return allLayers;
        */
        
        Map<String, Object> inputMap = new Map<String, Object> {
            'searchTerm' => searchTerm,
            'types' => types
        };
        
        return getLayersMoreOptions(inputMap);
    }
    
    @RemoteAction
    public static list<sma__MASavedQry__c> getLayersMoreOptions(Map<String, Object> inputMap) {
        String query = 'SELECT Id, Name, CreatedDate, sma__AdvancedOptions__c, sma__BaseObject__r.Name, sma__BaseObject__r.sma__Name__c, sma__BaseObject__r.sma__Type__c, sma__OrgWide__c, sma__Query__c,'
                            + ' sma__Folder__c, sma__Folder__r.Name, sma__Folder__r.sma__User__c, sma__Folder__r.sma__ParentFolder__c, sma__Folder__r.sma__ParentFolder__r.Name,'
                            + ' (SELECT Id, sma__Value__c, sma__Type__c from sma__Saved_Query_Components__r)'
                            + ' FROM sma__MASavedQry__c WHERE';

        if (inputMap.containsKey('types')) {
            List<String> typesList = ((String)inputMap.get('types')).split(',');
            query += ' sma__BaseObject__r.sma__Type__c IN :typesList';
        }
        
        if (inputMap.containsKey('searchTerm')) {
            String searchTerm = (String)inputMap.get('searchTerm');
            query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
        }

        if (inputMap.containsKey('objectTypes')) {
            List<String> objectTypes = ((String)inputMap.get('objectTypes')).split(',');
            query += ' AND sma__BaseObject__r.Name IN :objectTypes';
    }

        if (inputMap.containsKey('requiresGeoLocation') && (Boolean)inputMap.get('requiresGeoLocation')) {
            query += ' AND ((sma__BaseObject__r.sma__Latitude__c LIKE \'%Latitude\' OR sma__BaseObject__r.sma__Latitude__c LIKE \'%__s\')'
                    + ' AND (sma__BaseObject__r.sma__Longitude__c LIKE \'%Longitude\' OR sma__BaseObject__r.sma__Longitude__c LIKE \'%__s\'))';
    }

        query += ' ORDER BY Name';
       
        List<sma__MASavedQry__c> allLayers = Database.query(query);
       
        if (inputMap.containsKey('filterOutVariables') && (Boolean)inputMap.get('filterOutVariables')) {
            for (Integer i = allLayers.size() - 1, len = 0; i >= len; i--) {
                sma__MASavedQry__c savedQuery = allLayers[i];
       
                if (savedQuery.sma__Query__c.contains(':') || savedQuery.sma__Query__c.contains(' USING SCOPE ')) {
                    allLayers.remove(i);
       		}
       	    }
       }

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
        Map<String, Object> folderIds = new Map<String, Object>();
       
        for (sma__MAFolder__c fold : [SELECT Id, Name, sma__ParentFolder__c FROM sma__MAFolder__c]) {
            folderIds.put((String)fold.Id, (Object)fold);
        }


    
        return folderIds;
    }
}
