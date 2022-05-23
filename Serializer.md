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

## Rebuild Topics

### 单文件如果保存多个数据结构，如何区分数据，是否应该保存为单文件？
- Q1: 单文件如果保存多个数据结构，如何区分数据？  
  需要的数据结构有  
  - String
  - Map
  - Set
  - List
    - List of constants
    - List of maps
  
- Q2: 是否应该保存为单文件?

- Idea 1: 按照数据结构类型序列化数据
  - 每个k-v data 对应一个 Object
    - `Object(String key, Value value)`
    - `Value` => object / string / list / set
  - 1.1: 按数据结构组织文件
    - Adv
      - deserializing时较容易判断数据类型
    - Disadv
      - 可能会造成文件大小不均 => 对文件传输有影响(?但不大)
  - 1.2: 仍按照数据来源组织文件
    - Adv
      - 容易获得文件来源
    - Disadv
      - 难以区分数据类型
      - or, 使用json?
- Idea 2: 使用`Externalizable`
  
  


### 文件中单行数据怎么序列化比较好？是否使用java serialization技术序列化单个对象？

- IDEA 1: 使用`serialization`
  - 同上，需要在序列化前处理数据
- IDEA 2: 使用`Externalizable`
  - [参考文章1：序列化](https://juejin.cn/post/6844904168985985032)
  - 大致用法：自定义`writeExternal` && `readExternal`, 使每次只序列化一个data
  - Adv
    - 可以实现按data序列化
  - Disadv
    - 需要事先知道有哪些key，及value的类型

### 文件读取速度问题 (快速读取大文件)

#### [Tuning Java I/O Performance](https://www.oracle.com/technical-resources/articles/javase/perftuning.html)
- `FileInputStream`
  - `FileInputStream` only
  - This approach triggers a lot of calls to the underlying runtime system (`read()`)
  - `read()` used to return the next byte of the file

    ```Java
    import java.io.*;
    public class intro1 {     
      public static void main(String args[]) { 
        if (args.length != 1) {         
          System.err.println("missing filename");
          System.exit(1);  
        }       
        try { 
          FileInputStream fis = new FileInputStream(args[0]); 
          int cnt = 0; 
          int b; 
          while ((b = fis.read()) != -1) {  
            if (b == '\n') cnt++; 
          }         
          fis.close();  
          System.out.println(cnt);  
        } catch (IOException e) {         
          System.err.println(e);    
        }     
      }   
    }
    ```

- Using a Large Buffer
  - `FileInputStream` + `BufferedInputStream`
  - `BufferedInputStream.read` takes the next byte from the input buffer, and only rarely accesses the underlying system

  ```Java
  import java.io.*;
  public class intro2 {    
    public static void main(String args[]) { 
      if (args.length != 1) {       
        System.err.println("missing filename"); 
        System.exit(1); 
      }    
      try {       
        FileInputStream fis = new FileInputStream(args[0]);
        BufferedInputStream bis = new BufferedInputStream(fis);
        int cnt = 0;
        int b;
        while ((b = bis.read()) != -1) { 
          if (b == '\n')  cnt++; 
        }       
        bis.close(); 
        System.out.println(cnt); 
      } catch (IOException e) {       
        System.err.println(e);
      }   
    }  
  }
  ```

- Direct Buffering
  - `FileInputStream` + 定长buffer
  - 性能可能会比Using a Large Buffer好一些，但实现起来需要注意细节

  ```Java
  import java.io.*;  
  public class intro3 {     
    public static void main(String args[]) { 
    if (args.length != 1) {         
      System.err.println("missing filename");  
      System.exit(1); 
    }       
    try {         
      FileInputStream fis = new FileInputStream(args[0]); 
      byte buf[] = new byte[2048]; 
      int cnt = 0;     
      int n; 
      while ((n = fis.read(buf)) != -1) {  
        for (int i = 0; i < n; i++) { 
          if (buf[i] == '\n') cnt++; 
        }         
      }         
      fis.close();  
      System.out.println(cnt);   
    } catch (IOException e) {         
      System.err.println(e); 
    }     
   }   
  }
  ```

- Whole File
  - 先获得文件长度，再按照文件长度建立buffer
  - 缺点很明显：对于大文件不友好，可能没有足够memory

  ```Java
  import java.io.*;
  public class readfile {     
    public static void main(String args[]) { 
      if (args.length != 1) {         
        System.err.println("missing filename");
        System.exit(1);
      }      
      try {         
        int len = (int)(new File(args[0]).length()); 
        FileInputStream fis = new FileInputStream(args[0]);   
        byte buf[] = new byte[len];  
        fis.read(buf);    
        fis.close();   
        int cnt = 0;  
        for (int i = 0; i < len; i++) { 
          if (buf[i] == '\n')  cnt++;
        }         
        System.out.println(cnt);
      } catch (IOException e) {         
        System.err.println(e); 
      }     
    }   
  }
  ```

- Disabling Line Buffering
  - `PrintStream` is line buffered ( = `System.out`), 就是每遇到一个换行符就flush output buffer
  - 这里用`PrintStream`，把line buffer关闭 => 输出的速度确实变快

  ```Java
  import java.io.*;  
  public class bufout {     
    public static void main(String args[]) {
      FileOutputStream fdout = new FileOutputStream(FileDescriptor.out); 
      BufferedOutputStream bos = new BufferedOutputStream(fdout, 1024);
      PrintStream ps = new PrintStream(bos, false); 
      System.setOut(ps); 
      final int N = 100000; 
      for (int i = 1; i <= N; i++) 
        System.out.println(i);   
      ps.close();    
    }   
  }
  ```


### 验证方案可行性以及测试

### Others
- 传输整个文件的时候，为什么不直接用json传输？