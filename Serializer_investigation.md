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


| system            | with Gzip | no Gzip | 原本   |
| ----------------- | --------- | ------- | ------ |
| TargetValueSystem | 12Mb      | 67Mb    | 5924Kb |
| SlotSystem        | 12Kb      | 86Kb    | 9Kb    |
| TemplateSystem    | 67M       | 42Kb    | 9Kb    |

| system            | with Gzip | no Gzip | 原本 with Gzip | 原本 without Gzip |
| ----------------- | --------- | ------- | -------------- | ----------------- |
| TargetValueSystem | 1678ms    | 1577ms  | 2467ms         | 2401ms            |
| SlotSystem        | 42ms      | 38 - 50ms    | 15ms           |     16ms              |
| TemplateSystem    | 24ms      | 30ms    | 5ms            | 6ms               |
