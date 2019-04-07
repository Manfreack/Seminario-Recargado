using UnityEngine;

public class ExtraHealth : IPotionEffect {

    Model m;
    float timer;

    public ExtraHealth(Model M, float Timer)
    {
        m = M;
        timer = Timer;
    }

    public void PotionEffect()
    {
        timer -= Time.deltaTime;
        m.view.UpdateTimer(((int)timer).ToString());

        if (!m.armorActive)
        {
            m.armorActive = true;
            m.armor = m.maxArmor;
            m.view.UpdateArmorBar(m.armor / m.maxArmor);
            if(m.life > m.maxLife * 0.15f)
            {
                m.life -= m.maxLife * 0.15f;
                m.view.UpdateLifeBar(m.life / m.maxLife);
            }
            if(m.stamina > m.maxStamina * 0.15f)
            {
                m.stamina -= m.maxStamina * 0.15f;
                m.view.UpdateStaminaBar(m.stamina / m.maxStamina);
            }
        }
        if(timer <= 0)
        {
            m.armor = 0;
            m.armorActive = false;
            m.view.UpdateArmorBar(m.armor / m.maxArmor);
            m.view.UpdateTimer();
            m.currentPotionEffect = null;
        }
    }
}
