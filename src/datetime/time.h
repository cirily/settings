/*
 * Copyright (C) 2021 Piscesys Team.
 *
 * Author:     Reion Wong <reionwong@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef TIME_H
#define TIME_H

#include <QObject>
#include <QTime>
#include <QDate>
#include <QSettings>

class Time : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool useNtp READ useNtp WRITE setUseNtp NOTIFY useNtpChanged)
    Q_PROPERTY(QTime currentTime READ currentTime WRITE setCurrentTime NOTIFY currentTimeChanged)
    Q_PROPERTY(QDate currentDate READ currentDate WRITE setCurrentDate NOTIFY currentDateChanged)
    Q_PROPERTY(bool twentyFour READ twentyFour WRITE setTwentyFour NOTIFY twentyFourChanged)

public:
    explicit Time(QObject *parent = nullptr);

    bool useNtp() const;
    void setUseNtp(bool enabled);

    Q_INVOKABLE void save();

    QTime currentTime() const;
    void setCurrentTime(const QTime &currentTime);

    QDate currentDate() const;
    void setCurrentDate(const QDate &currentDate);

    bool twentyFour() const;
    void setTwentyFour(bool t);

signals:
    void useNtpChanged();
    void currentTimeChanged();
    void currentDateChanged();
    void twentyFourChanged();

private:
    bool m_useNtp;
    bool m_twentyFour;
    QTime m_currentTime;
    QDate m_currentDate;
    QSettings m_settings;
};

#endif // TIME_H
