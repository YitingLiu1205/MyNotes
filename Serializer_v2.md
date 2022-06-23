# Serializer Optimization Ver.2

## Commands!
- `java -Xmx16g -jar serializer/build/libs/local-build-serializer-0.0.1-SNAPSHOT.jar`
- `java -Xmx16g -XX:NativeMemoryTracking=detail -jar serializer/build/libs/local-build-serializer-0.0.1-SNAPSHOT.jar`

## Ver.1
- [PR](https://github.com/spotfront/hydra/pull/1746)
- [Design document](https://spotfront.atlassian.net/wiki/spaces/EN/pages/3310256618/Design+Doc+For+AdServer+Reload+Serializer+File+Optimization)

## 优化任务
- T1: 现有新Serializer与老Serializer的数据一致性测试，包括全量更新和差量更新
  - `SerializerCompareService` <= `tools/src/main/java/com/promoteiq/tools/service`
- T2: 将BatchUpdate逻辑推广到List Array这类有顺序信息的容器上，保证原有顺序和数据一致性以及更新效率
- T3: 梳理构建content，creative等基础数据表，构建以BasicTable, PrimaryTable为主的表内存结构

### T1

### T2

含有List的attributes:
| Type                                        | Name                                  | System                 | (List) Has order? | (List) Unique? |
| ------------------------------------------- | ------------------------------------- | ---------------------- | ----------------- | -------------- |
| `List<Integer>`                             | sharedBudgetIds                       | CreativeSystem         | No                | Might not ?    |
| `Map<Long, List<KeywordTarget>>`            | exactKeywordBoostIndexHashConflict    | KeywordTargetingSystem | No                | Yes            |
| `Map<Long, List<KeywordTarget>>`            | exactKeywordNegativeIndexHashConflict | KeywordTargetingSystem |                   |                |
| `Map<Integer, List<PlacementSlot>>`         | placementSlotMap                      | PlacementSlotSystem    | Yes (TreeSet)     | Yes            |
| `Map<Integer, List<Integer>>`               | placementGenericCampaignMap           | PlacementSlotSystem    |                   |                |
| `Map<Integer, Map<Integer, List<Integer>>>` | placementAudienceCampaignMap          | PlacementSlotSystem    |                   |                |
| `Map<Integer, List<CrossTargetingRule>>`    | crossTargetRuleIdsByOrganicTarget     | TargetValueSystem      |                   |                |
| `Map<Integer, List<CrossTargetingRule>>`    | crossTargetRulesByPlacementSlot       | TargetValueSystem      |                   |                |

#### 参考
- Map更新逻辑
    - Full update (currentMap, newMap)
      - 遍历currentMap, 记录不在newMap中 (要删掉的key), 放入needRemove
      - 从currentMap里删除needRemove
      - 遍历newMap, do insert and update to currentMap
    - Batch update (tableBatchData)
      - Update
        - currentTable = old map value
        - batchTable = new map value
        - Do add & update
          - Value = Map => Full update value map
          - Value = Set => Full update value set
          - **Value = List** => Full update value list
          - **Value = BasicTable** => Update BasicTable
            - Call updateData method
          - Value = Other => Full update value
      - Finalize
        - currentTable = old map value
        - 从currentMap里删除不在BatchUpdateKeyCache里的key

- Set更新逻辑
  - **Set of basic table**
    - 取出Id, 转成Map
      - => Full update map  => `Map<id, set item>`
      - => Delta update map => `Map<id, set item>`
  - Set of other objects
    - => Full update (currentSet, newSet)
      - 遍历currentSet, 记录不在newSet中的key,放入needRemove
      - 从currentSet里删除needRemove
      - currentSet |= newSet
    - => Batch update
      - 如果Item是
      - Update
        - currentTable = old set value
        - batchTable = new set value
        - Do add & update
      - Finalize
          - 从currentSet里删除不在BatchUpdateKeyCache里的Value
- **List更新逻辑**
  - Full update
    - 遍历old list和new list, 取出Id，build `map<id, idx at list>` (currentMap, newMap) 
    - 遍历currentMap, 记录不在newMap里的key, 放入needRemove
    - 把currentMap里needRemove对应的位置设置为`null`
    - 遍历newMap, do insert and update to currentMap
    - 遍历new list，把非non的pointer放入新list并返回

  - Batch update <= **目前没有应用场景**
    - 遍历old list和new list, 取出Id，build `map<id, pointer to old object>`  (currentMap, newMap) 
    - Update
        - Do add & update
          - Value = Map => Full update value map
          - Value = Set => Full update value set
          - **Value = List => Full update value list**
          - **Value = Basic => Update basic**
          - Value = Other => Full update value
      - Finalize
        - 把currentMap里needRemove对应的pointer指向`null`
        - 遍历newMap, do insert and update to currentMap
        - 遍历new list，把非non的pointer放入新list并返回

- **BasicTable**
  - Do object compare & update
    - extends Metadata class
      - 每个metadata 实现自己的update方法 <= Current
      - 用反射获取每个field的value, 并compare & update
    - 直接用 compareUtil, compare & update

### T3
