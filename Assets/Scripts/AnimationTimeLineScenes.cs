using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Timeline;
using UnityEngine.Playables;

public class AnimationTimeLineScenes : MonoBehaviour
{
    public List<PlayableDirector>TimeLineAnimations;

    public int value;

    public IEnumerator AnimationTimelinePlay()
    {
        foreach (var item in TimeLineAnimations)
        {
            yield return new WaitForSeconds(0.5f);
            item.Play();        
        }
    }

    public IEnumerator AnimationTimelineStop()
    {
        yield return new WaitForSeconds(0.5f);
        foreach (var item in TimeLineAnimations)
        {
            item.Stop();
        }
    }
}
