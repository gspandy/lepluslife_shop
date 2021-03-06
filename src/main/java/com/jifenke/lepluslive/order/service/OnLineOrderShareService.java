package com.jifenke.lepluslive.order.service;

import com.jifenke.lepluslive.lejiauser.domain.entities.LeJiaUser;
import com.jifenke.lepluslive.lejiauser.service.LeJiaUserService;
import com.jifenke.lepluslive.merchant.domain.entities.Merchant;
import com.jifenke.lepluslive.merchant.domain.entities.MerchantWalletOnline;
import com.jifenke.lepluslive.merchant.service.MerchantService;
import com.jifenke.lepluslive.merchant.service.MerchantWalletOnlineService;
import com.jifenke.lepluslive.order.controller.dto.OrderShare;
import com.jifenke.lepluslive.order.domain.entities.OnLineOrderShare;
import com.jifenke.lepluslive.order.repository.OnLineOrderShareRepository;
import com.jifenke.lepluslive.partner.domain.entities.Partner;
import com.jifenke.lepluslive.partner.domain.entities.PartnerManager;
import com.jifenke.lepluslive.partner.domain.entities.PartnerManagerWalletOnline;
import com.jifenke.lepluslive.partner.domain.entities.PartnerWalletOnline;
import com.jifenke.lepluslive.partner.service.PartnerManagerWalletOnlineService;
import com.jifenke.lepluslive.partner.service.PartnerWalletOnlineService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;

/**
 * 线上订单分润单 Created by zhangwen on 16/11/05.
 */
@Service
public class OnLineOrderShareService {
  @Inject
  private OnLineOrderShareRepository orderShareRepository;

  @Inject
  private MerchantWalletOnlineService merchantWalletOnlineService;

  @Inject
  private PartnerWalletOnlineService partnerWalletOnlineService;

  @Inject
  private PartnerManagerWalletOnlineService partnerManagerOnlineService;

  @Inject
  private LeJiaUserService leJiaUserService;

  @Inject
  private MerchantService merchantService;


  /**
   * 订单分润  核销时分润   17/06/22
   *
   * @param share 分润数据
   */
  @Transactional(propagation = Propagation.REQUIRED)
  public void share(OrderShare share) {
    LeJiaUser leJiaUser = leJiaUserService.findUserById(share.getUserId());

    Long type = share.getType();
    String orderSid = share.getOrderSid();
    OnLineOrderShare onLineOrderShare = new OnLineOrderShare();
    onLineOrderShare.setType(type.intValue());
    onLineOrderShare.setOrderSid(orderSid);
    onLineOrderShare.setShareMoney(share.getShareMoney());

    //添加分润记录
    if (share.getShareMoney() > 0) {
      long toMerchant = share.getShareToLockMerchant();
      long toPartner = share.getShareToLockPartner();
      long toPartnerManager = share.getShareToLockPartnerManager();
      long toTradePartner = share.getShareToTradePartner();
      long toTradePartnerManager = share.getShareToTradePartnerManager();
      long toLePlusLife = share.getToLePlusLife();

      if (leJiaUser.getBindMerchant() != null) {
        if (toMerchant > 0) {
          Merchant merchant = leJiaUser.getBindMerchant();
          //分润给绑定商户
          onLineOrderShare.setLockMerchant(merchant);
          if (merchant.getPartnership() == 2) {     //如果是虚拟商户分润方式改变
            toPartner += toMerchant;
            toMerchant = 0;
          } else {
            MerchantWalletOnline
                merchantWalletOnline =
                merchantWalletOnlineService.findByMercahnt(merchant);
            merchantWalletOnlineService
                .shareToMerchant(toMerchant, merchant,
                                 merchantWalletOnline,
                                 orderSid, type);
            onLineOrderShare.setLockMerchant(merchant);
          }
        }
      } else {
        toLePlusLife += toMerchant;
        toMerchant = 0;
      }

      // 对用户绑定合伙人进行分润
      Partner bindPartner = leJiaUser.getBindPartner();
      if (bindPartner != null) {
        if (toPartner > 0) {
          onLineOrderShare.setLockPartner(bindPartner);
          PartnerWalletOnline
              partnerWalletOnline =
              partnerWalletOnlineService.findByPartner(bindPartner);
          //分润给绑定合伙人
          partnerWalletOnlineService
              .shareToPartner(toPartner, bindPartner, partnerWalletOnline,
                              orderSid,
                              type);
        }
        // 对用户绑定的合伙人管理员
        PartnerManager bindPartnerManager = bindPartner.getPartnerManager();
        if (bindPartnerManager != null) {
          if (toPartnerManager > 0) {
            onLineOrderShare.setLockPartnerManager(bindPartnerManager);
            PartnerManagerWalletOnline
                partnerManagerWalletOnline =
                partnerManagerOnlineService.findByPartnerManager(bindPartnerManager);
            partnerManagerOnlineService
                .shareToPartnerManager(toPartnerManager,
                                       bindPartnerManager,
                                       partnerManagerWalletOnline, orderSid, type);
          }
        } else {
          toLePlusLife += toPartnerManager;
          toPartnerManager = 0;
        }
      } else {
        toLePlusLife = toLePlusLife + toPartner + toPartnerManager;
        toPartner = 0;
        toPartnerManager = 0;
      }

      if (share.getMerchantId() != 0) {
        // 对交易商户及合伙人进行分润
        Merchant merchant = merchantService.findMerchantById(share.getMerchantId());
        Partner tradePartner = merchant.getPartner();
        if (tradePartner != null) {
          if (toTradePartner > 0) {
            onLineOrderShare.setTradePartner(tradePartner);
            PartnerWalletOnline
                partnerWalletOnline =
                partnerWalletOnlineService.findByPartner(tradePartner);
            //分润给交易合伙人
            partnerWalletOnlineService
                .shareToPartner(toTradePartner, tradePartner, partnerWalletOnline,
                                orderSid,
                                type);
          }
          //分润给交易商户的合伙人管理员
          PartnerManager tradePartnerManager = tradePartner.getPartnerManager();
          if (tradePartnerManager != null) {
            if (toTradePartnerManager > 0) {
              onLineOrderShare.setTradePartnerManager(tradePartnerManager);
              PartnerManagerWalletOnline
                  partnerManagerWalletOnline =
                  partnerManagerOnlineService.findByPartnerManager(tradePartnerManager);
              partnerManagerOnlineService
                  .shareToPartnerManager(toTradePartnerManager,
                                         tradePartnerManager,
                                         partnerManagerWalletOnline, orderSid, type);
            }
          } else {
            toLePlusLife += toTradePartnerManager;
            toTradePartnerManager = 0;
          }
        } else {
          toLePlusLife = toLePlusLife + toTradePartner + toTradePartnerManager;
          toTradePartner = 0;
          toTradePartnerManager = 0;
        }
      }
      onLineOrderShare.setToLockMerchant(toMerchant);
      onLineOrderShare.setToLockPartner(toPartner);
      onLineOrderShare.setToLockPartnerManager(toPartnerManager);
      onLineOrderShare.setToTradePartner(toTradePartner);
      onLineOrderShare.setToTradePartnerManager(toTradePartnerManager);
      onLineOrderShare.setToLePlusLife(toLePlusLife);

      orderShareRepository.save(onLineOrderShare);
    }
  }

}
