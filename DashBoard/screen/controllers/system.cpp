#include "system.h"
#include <QDateTime>
System::System(QObject *parent)
    : QObject{parent}
    ,m_carLocked( true )
    ,m_outdoorTemp( 23 )
    ,m_userName("Ahmed Essam")

{
    m_currentTimeTimer = new QTimer(this);
    m_currentTimeTimer->setInterval(500);
    m_currentTimeTimer->setSingleShot( true );
    connect(m_currentTimeTimer, &QTimer::timeout, this, &System::currentTimeTimerTimeout);

    currentTimeTimerTimeout();

}

bool System::carLocked() const
{
    return m_carLocked;
}

int System::outdoorTemp() const
{
    return m_outdoorTemp;
}

QString System::userName() const
{
    return m_userName;
}

QString System::currentTime() const
{
    return m_currentTime;
}

void System::setcarLocked(bool carLocked)
{
    if (m_carLocked == carLocked)
        return;
    m_carLocked = carLocked;
    emit carLockedChanged(m_carLocked);
}

void System::setoutdoorTemp(int outdoorTemp)
{
    if(m_outdoorTemp == outdoorTemp)
        return;

    m_outdoorTemp = outdoorTemp;
    emit outdoorTempChanged(m_outdoorTemp);
}

void System::setuserName(const QString userName)
{
    if(m_userName == userName)
        return;
    m_userName = userName;
    emit userNameChanged(m_userName);
}

void System::setCurrentTime(const QString currentTime)
{
    if (m_currentTime == currentTime)
        return;
    m_currentTime = currentTime;
    emit currentTimeChanged(m_currentTime);
}

void System::currentTimeTimerTimeout()
{
    QDateTime dateTime;
    QString currentTime = dateTime.currentDateTime().toString("hh:mm ap");

    setCurrentTime( currentTime );

    m_currentTimeTimer->start();

}

