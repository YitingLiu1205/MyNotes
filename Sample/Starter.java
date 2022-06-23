package Sample;

import java.util.HashSet;
import java.util.Set;

public class Starter {
    public static void main(String[] args) {
        Set<Zoo> tmpSet = new HashSet<>();
        
        Zoo zoo1 = new Zoo(1, "a");
        Zoo zoo2 = new Zoo(2, "a");

        tmpSet.add(zoo1);
        tmpSet.add(zoo2);
        
        Zoo zoo3 = new Zoo(1, "b");
        System.out.println("in " + (tmpSet.contains(zoo3)));
    }
}