using System;

	public class EventFSM<T>
    {
		private FSM_State<T> current;

		public EventFSM(FSM_State<T> initial)
        {
			current = initial;
			current.Enter(default(T));
		}

		public void SendInput(T input)
        {
        FSM_State<T> newState;

			if (current.CheckInput(input, out newState))
            {
				current.Exit(input);
				current = newState;
				current.Enter(input);
			}
		}

		public FSM_State<T> Current { get { return current; } }

		public void Update()
        {
			current.Update();
		}

        public void LateUpdate()
        {
            current.LateUpdate();
        }

        public void FixedUpdate()
        {
            current.FixedUpdate();
        }
	}
