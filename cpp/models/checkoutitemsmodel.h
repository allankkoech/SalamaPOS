#ifndef CHECKOUTITEMSMODEL_H
#define CHECKOUTITEMSMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include "checkoutitems.h"

class CheckoutItemsModel : public QAbstractListModel
{
    Q_OBJECT

    enum SellItemRoles{
        SellBarcodeRole = Qt::UserRole+1,
        SellItemNameRole,
        SellItemUnitRole,
        SellItemBpRole,
        SellItemSpRole,
        SellQtyRole
    };

public:
    explicit CheckoutItemsModel(QObject *parent = nullptr);

    // QAbstractListModel overrides
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

    QVariant data(const QModelIndex &index, int role) const;

    bool setData(const QModelIndex &index, const QVariant &value, int role);

    Qt::ItemFlags flags(const QModelIndex &index) const;

    QHash<int, QByteArray> roleNames() const;

signals:

private:
    CheckoutItems * m_checkoutItem;
};

#endif // CHECKOUTITEMSMODEL_H
