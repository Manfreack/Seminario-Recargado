using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class StateMachine {

    public State _currentState;
    List<State> _states = new List<State>();

    /// <summary>
    /// Llama al execute del estado actual.
    /// </summary>
	public void Update()
    {
        if (_currentState != null)
            _currentState.Execute();
    }

    /// <summary>
    /// Agrega un estado.
    /// </summary>
    /// <param name="s">El estado a agregar.</param>
    public void AddState(State s)
    {
        _states.Add(s);
        if (_currentState == null)
            _currentState = s;
    }

    /// <summary>
    /// Cambia de estado.
    /// </summary>
    /// <param name="s">Tipo de estado.</param>
    public void SetState<T>() where T : State
    {
        for (int i = 0; i < _states.Count; i++)
        {
            if (_states[i].GetType() == typeof(T))
            {
                _currentState.Sleep();
                _currentState = _states[i];
                _currentState.Awake();
            }
        }
    }

    public bool IsActualState<T>() where T : State
    {
        return _currentState.GetType() == typeof(T);
    }

    /// <summary>
    /// Busca el índice de un estado por su tipo.
    /// </summary>
    /// <param name="t">Tipo de estado.</param>
    /// <returns>Devuelve el índice.</returns>
    private int SearchState(Type t)
    {
        int ammountOfStates = _states.Count;
        for (int i = 0; i < ammountOfStates; i++)
            if (_states[i].GetType() == t)
                return i;
        return -1;
    }
}
