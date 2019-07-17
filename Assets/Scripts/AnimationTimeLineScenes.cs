using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Timeline;
using UnityEngine.Playables;

public class AnimationTimeLineScenes : MonoBehaviour
{

    public PlayableDirector CutScene01;
    public PlayableDirector CutScene02;
    public PlayableDirector CutScene02_Bars;

    public int value;

    public IEnumerator CutSceneRocks()
    {

        yield return new WaitForSeconds(0.5f);
        if (CutScene01)
        {
            CutScene01.Play(); 
        }
    }
    public IEnumerator CutSceneLever()
    {

        yield return new WaitForSeconds(0.5f);
        if (CutScene02)
        {
            CutScene02.Play(); 
        }

        yield return new WaitForSeconds(4);

        if (CutScene02_Bars)
        {
            CutScene02_Bars.Play();
        }
    }


}
