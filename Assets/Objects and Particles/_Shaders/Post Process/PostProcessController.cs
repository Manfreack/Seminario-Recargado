using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PostProcessController : MonoBehaviour
{
    public Material mat;

    [Range(0, 1)]
    public float FillAmount;

    [Range(0, 1)]
    public float BaseOverlay;

    [Range(0, 1)]
    public float OverlayExtraIntensity;

    public Model player;

    void Start()
    {
        player = FindObjectOfType<Model>();
    }

    void Update()
    {
        if(player.life <=30 && player.life>10)
        {
            FillAmount += Time.deltaTime / 5;
            OverlayExtraIntensity += Time.deltaTime /5;
            if (FillAmount > 0.5f) FillAmount = 0.5f;
            if (OverlayExtraIntensity > 0.05f) OverlayExtraIntensity = 0.05f;
        }

        if(player.life <=10)
        {
            FillAmount += Time.deltaTime /5;
            OverlayExtraIntensity += Time.deltaTime /5;
            if (FillAmount > 1) FillAmount = 1;
            if (OverlayExtraIntensity > 0.08f) OverlayExtraIntensity = 0.08f;
        }

        if(player.life>=50)
        {
            FillAmount -= Time.deltaTime;
            OverlayExtraIntensity -= Time.deltaTime / 5;
            if (FillAmount < 0) FillAmount = 0;
            if (OverlayExtraIntensity < 0) OverlayExtraIntensity = 0f;
        }

        mat.SetFloat("_HitFillAmount", FillAmount);
        mat.SetFloat("_HitOverlayExtraIntensity", OverlayExtraIntensity);

    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, mat);
    }
}
