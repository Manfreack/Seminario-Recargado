using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rune : MonoBehaviour
{
    public float healingAmount;
    bool used;
    Renderer r;

    void Start()
    {
        used = false;
        r = GetComponent<Renderer>();
    }

    void OnTriggerEnter(Collider c)
    {
        if (!used)
        {
            Model player = c.gameObject.GetComponent<Model>();
            if (player)
            {
                player.life += healingAmount;
                player.view.UpdateLifeBar(player.life / player.maxLife);
                StartCoroutine(Use());
            }
        }
    }

    IEnumerator Use()
    {
        used = true;
        float time = 0;

        while (time < 1)
        {
            time += Time.deltaTime;
            float red = Mathf.Lerp(0, 255, time);
            r.material.color = new Color(red, 0, 0);
            yield return new WaitForEndOfFrame();
        }
    }
}
