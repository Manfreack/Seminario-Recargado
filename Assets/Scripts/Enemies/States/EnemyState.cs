using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyState : State
{
    protected EnemyClass npc;

    public EnemyState(StateMachine sm, EnemyClass e) : base(sm)
    {
        npc = e;
    }
}
