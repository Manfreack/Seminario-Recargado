using UnityEngine;

public class Health : IPotionEffect {

    Model m;
    float hp;
    float thp;

    public Health(Model M, float HP, float THP)
    {
        m = M;
        hp = HP;
        thp = THP;
    }

    public void PotionEffect()
    {
        float limit = hp + (thp / 4) < thp ? hp + (thp / 4) : thp;
        if (m.life < limit)
        {
            m.life += 50 * Time.deltaTime;
            m.view.UpdateLifeBar(m.life / thp);
        }
        else
            m.currentPotionEffect = null;
    }
}
