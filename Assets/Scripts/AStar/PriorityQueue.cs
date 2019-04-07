using System;
using System.Collections.Generic;

public class PriorityQueue<TData>
{
    public bool IsEmpty { get { return data.Count <= 0; } }

    private List<Tuple<TData, float>> data;

    public PriorityQueue()
    {
        data = new List<Tuple<TData, float>>();
    }

    public void Enqueue(TData data, float priority)
    {
        Enqueue(new Tuple<TData, float>(data, priority));
    }

    public TData Dequeue()
    {
        return DequeuePair().Item1;
    }

    public void Enqueue(Tuple<TData, float> pair)
    {
        data.Add(pair);

        var curIndex = data.Count - 1;
        if (curIndex == 0) return;

        var parentIndex = (int)(curIndex - 1) / 2;

        while (data[curIndex].Item2 < data[parentIndex].Item2)
        {
            Swap(curIndex, parentIndex);

            curIndex = parentIndex;
            parentIndex = (int)(curIndex - 1) / 2;
        }
    }

    public Tuple<TData, float> DequeuePair()
    {
        var min = data[0];

        data[0] = data[data.Count - 1];
        data.RemoveAt(data.Count - 1);

        if (data.Count == 0) return min;

        int curIndex = 0;
        int leftIndex = 1;
        int rightIndex = 2;
        int minorIndex;

        if (data.Count > rightIndex)
            minorIndex = data[leftIndex].Item2 < data[rightIndex].Item2 ? leftIndex : rightIndex;
        else if (data.Count > leftIndex)
            minorIndex = leftIndex;
        else return min;

        while (data[minorIndex].Item2 < data[curIndex].Item2)
        {
            Swap(minorIndex, curIndex);

            curIndex = minorIndex;
            leftIndex = curIndex * 2 + 1;
            rightIndex = curIndex * 2 + 2;

            if (data.Count > rightIndex)
                minorIndex = data[leftIndex].Item2 < data[rightIndex].Item2 ? leftIndex : rightIndex;
            else if (data.Count > leftIndex)
                minorIndex = leftIndex;
            else return min;
        }

        return min;
    }

    private void Swap(int i1, int i2)
    {
        var aux = data[i1];
        data[i1] = data[i2];
        data[i2] = aux;
    }

}
