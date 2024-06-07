# UnityShaderUIImageBlurAndOutLine
对一个UGUI的Image使用，可以令Image后方高斯模糊，且令Image有固定像素宽度的边框。边框宽度与颜色可自定义。
用法（伪代码）：
``` C#
using UnityEngine.UI;//Image
public GameObject A;//UGUI Panel
A.SetOutLineWithBlur();
```
效果：
![image](01.png)