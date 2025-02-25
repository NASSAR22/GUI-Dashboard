#ifndef SYSTEM_H
#define SYSTEM_H
#include <QTimer>
#include <QObject>

class System : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool carLocked READ carLocked WRITE setcarLocked NOTIFY carLockedChanged FINAL)
    Q_PROPERTY(int outdoorTemp READ outdoorTemp WRITE setoutdoorTemp NOTIFY outdoorTempChanged FINAL)
    Q_PROPERTY(QString userName READ userName WRITE setuserName NOTIFY userNameChanged FINAL)
    Q_PROPERTY(QString currentTime READ currentTime WRITE setCurrentTime NOTIFY currentTimeChanged FINAL)
public:
    explicit System(QObject *parent = nullptr);
    
    bool carLocked() const;

    int outdoorTemp() const;

    QString userName() const;

    QString currentTime() const;




public slots:
    void setcarLocked(bool carLocked);

    void setoutdoorTemp(int outdoorTemp);

    void setuserName(const QString userName);

    void setCurrentTime(const QString currentTime);

    void currentTimeTimerTimeout();

signals:
    void carLockedChanged(bool carLocked);

    void outdoorTempChanged(int outdoorTemp);

    void userNameChanged(QString userName);

    void currentTimeChanged(QString currentTime);


private:
    bool m_carLocked;
    int m_outdoorTemp;
    QString m_userName;
    QString m_currentTime;
    QTimer * m_currentTimeTimer;
};

#endif // SYSTEM_H
