# Serializer Optimization Ver.2

## Ver.1
- [PR](https://github.com/spotfront/hydra/pull/1746)
- [Design document](https://spotfront.atlassian.net/wiki/spaces/EN/pages/3310256618/Design+Doc+For+AdServer+Reload+Serializer+File+Optimization)

## 可能可以改进的点
- List没有实现partial update
- Field[] 可以分给各个class
- MetaData里的class没有内存引用更新
- 目前copy指针只指到table, 或许可以指到row?

## 优化任务
- 现有新Serializer与老Serializer的数据一致性测试，包括全量更新和差量更新
- 将BatchUpdate逻辑推广到List Array这类有顺序信息的容器上，保证原有顺序和数据一致性以及更新效率
- 梳理构建content，creative等基础数据表，构建以BasicTable, PrimaryTable为主的表内存结构
