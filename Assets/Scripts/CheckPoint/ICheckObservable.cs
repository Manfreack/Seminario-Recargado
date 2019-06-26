using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ICheckObservable {

    void Subscribe(ICheckObserver observer);
    void Unsubscribe(ICheckObserver observer);
}
