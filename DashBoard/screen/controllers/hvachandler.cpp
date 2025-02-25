#include "hvachandler.h"

HVACHandler::HVACHandler(QObject *parent)
    : QObject{parent}
    ,m_targetTemperature( 30 )
{}

int HVACHandler::targetTemperature() const
{
    return m_targetTemperature;
}

void HVACHandler::incrementTargetTemperature(const int &val)
{
    int newTaregetTemp = m_targetTemperature + val;
    setTargetTemperature( newTaregetTemp );
}

void HVACHandler::setTargetTemperature(int targetTemperature)
{
    if(m_targetTemperature == targetTemperature)
        return;

    m_targetTemperature = targetTemperature;
    emit targetTemperatureChanged(m_targetTemperature);
}


