using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class DestructibleOBJ : MonoBehaviour
{
    public GameObject principalMesh;
    public GameObject destructibleMesh;
    public BoxCollider myBox;
    public Animator anim;
    BoxCollider col;
    Material mat;
    float time;
    bool first;
    bool change;
    public Rigidbody rb;

    public List<GameObject> itemPrefabs;
    bool spawnItem = false;
    public LayerMask lm;
    bool alreadySelected = false;
    public float range;

    public IEnumerator Destroy()
    {
        yield return new WaitForSeconds(5);
        Destroy();
    }

    public IEnumerator startDisolve()
    {
        if (!first)
        {
            SpawnItem();
            first = true;
            principalMesh.SetActive(false);
            destructibleMesh.SetActive(true);
            anim.SetBool("IsHit", true);
            myBox.isTrigger = true;
            yield return new WaitForSeconds(5);
            col.isTrigger = true;
            StartCoroutine(Destroy());
        }
    }

    public void Start()
    {
        rb = destructibleMesh.GetComponent<Rigidbody>();
        anim = destructibleMesh.GetComponent<Animator>();
        col = destructibleMesh.GetComponent<BoxCollider>();
        mat = principalMesh.GetComponent<MeshRenderer>().materials[0];
        myBox = GetComponent<BoxCollider>();
        SetSpawn();
    }

    public void Update()
    {
        if (!change)
        {
            time -= Time.deltaTime;
            if (time <= 0) change = true;
        }
        else
        {
            time += Time.deltaTime;
            if (time >= 1) change = false;
        }

        mat.SetFloat("_Opacity", time);
    }

    public void SetSpawn()
    {
        Collider[] colliders = Physics.OverlapSphere(transform.position, range, lm);
        List<Collider> destructiblesInRange = new List<Collider>();
        foreach (var i in colliders)
            if(i.GetComponent<DestructibleOBJ>())
                destructiblesInRange.Add(i);

        int random = Random.Range(0, destructiblesInRange.Count - 1);
        for (int i = 0; i < destructiblesInRange.Count; i++)
        {
            DestructibleOBJ comp = destructiblesInRange[i].GetComponent<DestructibleOBJ>();
            if (!comp.alreadySelected)
            {
                comp.spawnItem = i == random;
                comp.alreadySelected = true;
            }
        }
    }

    private void OnDrawGizmos()
    {
        //Gizmos.color = Color.white;
        //Gizmos.DrawWireSphere(principalMesh.transform.position, range);
    }

    public void SpawnItem()
    {
        if (spawnItem)
        {
            GameObject item = Instantiate(itemPrefabs[Random.Range(0, itemPrefabs.Count)]);
            item.transform.position = transform.position;
        }
    }
}
