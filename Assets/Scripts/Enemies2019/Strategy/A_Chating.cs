using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class A_Chating : i_EnemyActions
{
    EnemyEntity _e;

    public A_Chating (EnemyEntity e)
    {
        _e = e;
    }

    public void Actions()
    {
        _e.chatCurrentTime -= Time.deltaTime;
        if(_e.chatCurrentTime <= 0)
        {
            _e.ChangeChatAnimation();
            _e.chatCurrentTime = _e.timeToChat;
        }
    }

   
}
