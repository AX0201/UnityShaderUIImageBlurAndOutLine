using UnityEngine;//Mono
using UnityEngine.UI;//Image

namespace CMKZ {
    public static partial class LocalStorage {
        public static void SetOutLineWithBlur(this GameObject X, Color Y = default, float 边框宽度 = 2, float 模糊度 = 4, bool Mix = false) {
            if (Y == default) {
                Y = new Color(1, 1, 1, 1);
            }
            X.AddComponent<ShaderOutLine>().Color = Y;
            X.GetComponent<ShaderOutLine>().边框宽度 = 边框宽度;
            X.GetComponent<ShaderOutLine>().模糊度 = 模糊度;
            X.GetComponent<ShaderOutLine>().Mix = Mix;
            X.GetComponent<ShaderOutLine>().Active();
        }
    }
    public class ShaderOutLine : MonoBehaviour {
        public Color Color;
        public float 边框宽度;
        public float 模糊度;
        public Vector2 尺寸;
        public bool Mix;//是否混合Image本身的Color。默认不混合，即本身Color失效
        public void Start() {

        }
        //当焦点变化时刷新，避免Unity bug
        public void OnApplicationFocus(bool focus) {
            //Active();
        }
        public void Active() {
            if (GetComponent<Image>() == null) {
                gameObject.AddComponent<Image>().color = new Color(1, 1, 1, 0.1f);//白色
            }
            GetComponent<Image>().material = new Material(Shader.Find("Custom/模糊与描边3"));
            GetComponent<Image>().material.SetColor("BorderC", Color);
            GetComponent<Image>().material.SetColor("SelfColor", gameObject.GetComponent<Image>().color);
            GetComponent<Image>().material.SetFloat("Size", 模糊度);
            GetComponent<Image>().material.SetFloat("BorderW", 边框宽度);
            GetComponent<Image>().material.SetInt("Mix", Mix ? 1 : 0);
            GetComponent<Image>().material.SetVector("Rect", 尺寸 = new Vector2(GetComponent<RectTransform>().rect.width, GetComponent<RectTransform>().rect.height));
        }
        //当尺寸变化时刷新，重新计算边框
        public void OnRectTransformDimensionsChange() {
            GetComponent<Image>().material.SetVector("Rect", 尺寸 = new Vector2(GetComponent<RectTransform>().rect.width, GetComponent<RectTransform>().rect.height));
        }
    }
}