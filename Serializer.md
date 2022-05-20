# Serializer Rebuild

## How is the code organized?

- Start from `SerializerCommandLine.java`
  - Step 1: Run `Creative System`
  - Step 2: Run `TargetValue System`
  - Step 3: Run `Slot System`
  - Step 4: Run `Template System`
  - Step 5: Run `PlacementSlot System`
  - Step 6: Run `KeywordTargeting System`

### Gradle
- 用于打包，类似`bazel`
- [如何通俗地理解 Gradle？](https://www.zhihu.com/question/30432152)

## Issues in prev version
- Problem 1: AD Server reload Serializer结果时，会出现Java GC导致的扩容问题
  - How it happened?
    - 由于每次reload都会把原数据复制一份，然后在复制后的数据上进行更改。会导致原本的数据进入老年代，且一直不会被释放，直到Java内存满了并触发GC后。在这个过程中，会导致Ad Server自动扩容。
  - How to improve?
    - Step 1: 把原本的数据复制，改为复制指针
      - 如果新数据和原数据一样，则复制原数据
      - 如果被删除，则删除指针，不进行复制
      - 如果被更改，则复制更改后的
- Problem 2: Serializer是对整个文件进行阅读，不适合Problem 1中的改造方案，且开销较大
  - How to improve?
    - Method 1: 由按文件读，改为按行读

## Rebuild

- 入手点：`writeObject(object, filename, useGzip)`