
# JAVA & Spring Boot

## Java 装饰器

- `@slf4j`
  - slf4j是一个日志标准，使用它可以完美的桥接到具体的日志框架，必要时可以简便的更换底层的日志框架，而不需要关心具体的日志框架的实现（slf4j-simple、logback等）
  - 相当于门面模式中的门面（外观对象），它知道各个子系统的功能，负责把客户的请求按需分配给某一子系统，但不参入子系统的业务逻辑的实现
  - 在类上添加`@Slf4j`注解，在方法中直接使用`log`
  - [Java日志框架：slf4j作用及其实现原理](https://www.cnblogs.com/xrq730/p/8619156.html)
  - [@Slf4j 注解的使用方法](https://www.jianshu.com/p/e80ab37294ed)
- `@PostConstruct`
  - 当依赖注入完成后用于执行初始化的方法，并且只会被执行一次
  - `Constructor(构造方法) -> @Autowired(依赖注入) -> @PostConstruct(注释的初始化方法)`

## Spring 装饰器
- `@Component`

- `@Bean`
  - [Spring框架-Bean详解](https://www.lyclife.com/2021/07/spring%E6%A1%86%E6%9E%B6-bean%E8%AF%A6%E8%A7%A3/)
  - **Bean**  
    - Spring Bean是被Spring实例化、组装并由Spring容器管理的Java对象。
    - 默认情况下，Spring中的bean都是单例的。
- `@Value`
  - 作用是通过注解将常量、配置文件中的值、其他bean的属性值注入到变量中，作为变量的初始值
  - Usage:
    - `@Value("常量")`：常量注入，*可以使用但没有读取配置文件的方式灵活*
    - `@Value(“${}” : default_value)`: 读取配置文件
    - `@Value(“#{}”? : default_value) `: 读取注入bean的属性,也可添加默认值
  - Example:
    - `@Value("${delivery.version:unknown}")`: 读取某配置文件（e.g. `.yml`结尾的文件），取出`delivery.version`的值，赋值给被装饰的var
- `@Autowired`
  - `Autowire` = 自动装配
  - 将 Spring 容器中的 bean 自动的和我们需要这个 bean 的类组装在一起。

## Lombok
- `@Synchronized`
  - [Lombok之@Synchronized使用](https://blog.csdn.net/cauchy6317/article/details/102812229)
  - 是一种同步锁，主要用来保证在同一个时刻，只有一个线程可以执行某个方法或者某段代码块

## Others

- `@interface`
    - `@interface` 不是`interface`，是注解类, 用于定义一个可用的注解
- `Stream.of`
  - 用于为给定元素创建顺序流
  - `Stream.of创建`有限元流。为了创建一个无限元素流，我们可以使用`Stream.generate`方法。
  - **数据流**：是指一组有顺序的、有起点和终端的字节集合，是对输入/输出的总称