using UnityEngine;
using System.Collections;

public abstract class State
{
    StateMachine _sm;

    /// <summary>
    /// Crea el estado.
    /// </summary>
    /// <param name="sm">Máquina de estados que va a recibir al estado.</param>
    public State(StateMachine sm)
    {
        _sm = sm;
    }

    /// <summary>
    /// Función que se llama cuando se entra al estado.
    /// </summary>
    public virtual void Awake() { }

    /// <summary>
    /// Función que se llama cuando se sale del estado.
    /// </summary>
    public virtual void Sleep() { }

    /// <summary>
    /// Función que se llama constantemente mientras se encuentre en el estado.
    /// </summary>
    public virtual void Execute() { }

}
