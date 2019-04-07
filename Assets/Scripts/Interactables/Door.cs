using System.Collections;
using UnityEngine;

public class Door : Interactable {
    bool isActive = false;
    public Transform door;

    public override void Interaction()
    {
        if(!isActive)
            StartCoroutine(Rot());
    }

    IEnumerator Rot()
    {
        isActive = true;
        while (door.rotation.y > 0)
        {
            door.Rotate(0, -90 * Time.deltaTime, 0);
            yield return null;
        }
    }
}
