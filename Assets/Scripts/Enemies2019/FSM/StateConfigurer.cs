using System.Collections.Generic;


	public class StateConfigurer<T>
    {
    FSM_State<T> instance;
		Dictionary<T, Transition<T>> transitions = new Dictionary<T, Transition<T>>();

		public StateConfigurer(FSM_State<T> state) {
			instance = state;
		}

		public StateConfigurer<T> SetTransition(T input, FSM_State<T> target) {
			transitions.Add(input, new Transition<T>(input, target));
			return this;
		}

		public void Done() {
			instance.Configure(transitions);
		}
	}

	public static class StateConfigurer
    {
		public static StateConfigurer<T> Create<T>(FSM_State<T> state)
        {
			return new StateConfigurer<T>(state);
		}
	}
