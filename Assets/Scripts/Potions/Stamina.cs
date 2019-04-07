using UnityEngine;

public class Stamina : IPotionEffect {

    Model m;
    float sta;
    float tsta;

    public Stamina(Model M, float STA, float TSTA)
    {
        m = M;
        sta = STA;
        tsta = TSTA;
    }

    public void PotionEffect()
    {
        float limit = sta + ((tsta / 10) * 3) < tsta ? sta + ((tsta / 10) * 3) : tsta;
        if (m.stamina < limit)
        {
            m.stamina += 60 * Time.deltaTime;
            m.view.UpdateStaminaBar(m.stamina / tsta);
        }
        else
            m.currentPotionEffect = null;
    }
}
