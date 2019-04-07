using System;

	public class Transition<T>
    {
		public event Action<T> OnTransition = delegate { };
		public T Input { get { return input; } }
		public FSM_State<T> TargetState { get { return targetState;  } }

		T input;
        FSM_State<T> targetState;

		public void OnTransitionExecute(T input)
        {
			OnTransition(input);
		}

		public Transition(T input, FSM_State<T> targetState)
        {
			this.input = input;
			this.targetState = targetState;
		}
	}
