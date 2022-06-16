# Investigation on serializer & reload

## Serialize

### TargetValueSystem - 5924KB
  | Method      | Runtime | Memory usage | Size of file |
  | ----------- | ------- | ------------ | ------------ |
  | Original    | --      | --           | --           |
  | Depth two   | --      | --           | --           |
  | Depth three | --      | --           | --           |

### SlotSystem - 9KB

  | Method      | Runtime | Memory usage | Size of file |
  | ----------- | ------- | ------------ | ------------ |
  | Original    | --      | --           | --           |
  | Depth two   | --      | --           | --           |
  | Depth three | --      | --           | --           |

### TemplateSystem - 9KB
| Method      | Runtime | Memory usage | Size of file |
| ----------- | ------- | ------------ | ------------ |
| Original    | --      | --           | --           |
| Depth two   | --      | --           | --           |
| Depth three | --      | --           | --           |

## Deserialize

### TargetValueSystem - 5924KB
  | Method      | Runtime | Memory usage |
  | ----------- | ------- | ------------ |
  | Original    | 1687 ms | --           |
  | Depth two   | --      | --           |
  | Depth three | --      | --           |

### SlotSystem - 9KB
| Method      | Runtime | Memory usage |
| ----------- | ------- | ------------ |
| Original    | 130ms   | --           |
| Depth two   | --      | --           |
| Depth three | --      | --           |

### TemplateSystem - 9KB
| Method      | Runtime | Memory usage |
| ----------- | ------- | ------------ |
| Original    | 4ms     | --           |
| Depth two   | --      | --           |
| Depth three | --      | --           |


| system              | with Gzip | no Gzip | 数据Gzip压缩 without 文件Gzip | 数据压缩 with Gzip | 原本     |
| ------------------- | --------- | ------- | ----------------------------- | ------------------ | -------- |
| TargetValueSystem   | 12M       | 67M     | 12M                           | 7.6M               | 5.924Mb  |
| PlacementSlotSystem |           |         | 105M                          | 57M                | 79.969Mb |

| system              | with Gzip | no Gzip | 数据Gzip压缩 without 文件Gzip | 数据压缩 with Gzip | 原本 without Gzip |
| ------------------- | --------- | ------- | ----------------------------- | ------------------ | ----------------- |
| TargetValueSystem   | 1678ms    | 1577ms  | 2178ms                        | 2246ms             | 2467ms            |
| PlacementSlotSystem |           |         | 45564ms                       | 37881ms            | 49310ms  47498ms  |