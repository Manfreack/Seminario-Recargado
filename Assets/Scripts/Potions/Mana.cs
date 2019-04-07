using UnityEngine;

public class Mana : IPotionEffect {

    Model m;
    float mana;
    float tmana;

    public Mana(Model M, float MANA, float TMANA)
    {
        m = M;
        mana = MANA;
        tmana = TMANA;
    }

    public void PotionEffect()
    {
        float limit = mana + ((tmana / 10) * 3) < tmana ? mana + ((tmana / 10) * 3) : tmana;
        if (m.mana < limit)
        {
            m.mana += 60 * Time.deltaTime;
            m.view.UpdateManaBar(m.mana / tmana);
        }
        else
            m.currentPotionEffect = null;
    }
}
