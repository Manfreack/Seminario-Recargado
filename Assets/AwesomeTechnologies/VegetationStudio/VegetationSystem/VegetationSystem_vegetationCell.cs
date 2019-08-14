using System.Collections.Generic;
using AwesomeTechnologies.Vegetation;
using UnityEngine;

namespace AwesomeTechnologies
{
    public partial class VegetationSystem
    {
        [Header("Vegetation cells")]
        [System.NonSerialized]
        public List<VegetationCell> VegetationCellList = new List<VegetationCell>();
        [System.NonSerialized]
        public List<VegetationCell> PotentialVisibleVegetationCellList = new List<VegetationCell>();
        //private VegetationCellCacheController _vegetationCellCacheController;

        //public delegate void MultiVegetationCellClearCacheDelegate(VegetationCell vegetationCell);
        //public MultiVegetationCellClearCacheDelegate OnVegetationCellClearCacheDelegate;

        public delegate void MultionClearCacheDelegate();

        public MultionClearCacheDelegate OnClearCacheDelegate;
        private VegetationCachePool _vegetationCachePool;

        void SetupCache()
        {
            if (_vegetationCachePool == null) _vegetationCachePool = new VegetationCachePool();
            _vegetationCachePool.VegetationPackage = CurrentVegetationPackage;
            _vegetationCachePool.VegetationSettings = vegetationSettings;
            _vegetationCachePool.CellSize = CellSize;
            _vegetationCachePool.InitCachePool();

            System.GC.Collect();
        }

        public void UpdateVegetationCells()
        {
            for (int i = 0; i <= VegetationCellList.Count - 1; i++)
            {
                VegetationCellList[i].CurrentvegetationPackage = CurrentVegetationPackage;
                VegetationCellList[i].UnityTerrainData = this.UnityTerrainData;
            }

            SetDirty();
        }

        //void OnvegetationCellClearCache(VegetationCell vegetationCell)
        //{
        //    SetDirty();

        //    if (OnVegetationCellClearCacheDelegate != null) OnVegetationCellClearCacheDelegate(vegetationCell);

        //}

        public void ClearVegetationCellCache()
        {
            for (int i = 0; i <= VegetationCellList.Count - 1; i++)
            {
                VegetationCellList[i].ClearCache(false);
            }

#if UNITY_EDITOR
            System.GC.Collect();
#endif
            if (OnClearCacheDelegate != null) OnClearCacheDelegate();

            SetDirty();
        }
    }
}