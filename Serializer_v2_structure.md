
## Write DataSystem

- TabelSetConfig
  - `Class<?> tableSetClazz`
  - `LinkedHashMap<String, TableInfo> tableInfoMap`
    - Map => KvTableInfo
    - Set/List => SingleLineTableInfo
      - Set => Batch
      - List => 整个Write
    - Other types => SingleValueTableInfo

## Read DataSystem

- No batch => Replace current data
- With batch
  - Add && Update
    - Map
      - Map => Full update map => Compare key
      - List => Full update list 
        - With BasicTable
          - new list: `map<id(BasicTable), number of items with same id>`
          - emptySpaces: `List<index of need remove items in currentList>`
          - currentItemMap: `map<id(BasicTable), SortedSet<index of item with same ID in currentList>`
      - Set => Full update set
        - With BasicTable
          - `map<id, List<item>>`
        - Without BasicTable
    - Set
      - With BasicTable
        - `map<id, List<item>>`
      - Without BasicTable
  - Do delete
    - Map => remove key not in `getBatchUpdateKeyCache()`
    - Set
      - BasicTable => remove uniqueId not in `getBatchUpdateKeyCache()`
      - Other => remove item not in `getBatchUpdateKeyCache()`
