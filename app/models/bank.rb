# -*- coding: utf-8 -*-

class Bank < ActiveRecord::Base
  has_many :bank_branches

  validates :zengin_code, presence: true,
                          format: {
                              with:    /\A[0-9]*\z/,
                              message: 'は数字(ハイフンなし)で入力してください。'
                          },
                          numericality: {
                              greater_than_or_equal_to: 1,
                              less_than_or_equal_to: 9999,
                          },
                          uniqueness: true

  validates :name,        presence: true,
                          length: {
                              maximum: 64,
                          },
                          format: {
                              with: /\A\S+\z/,
                          },
                          uniqueness: true

  validates :name_kana,   presence: true,
                          length: {
                            maximum: 128,
                          },
                          format: {
                              with: /\A[アイウエオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモヤユヨラリルレロワヲンA-Za-zー・]*\z/,
                          }

  def zengin_code_to_s
    "%04d" % self.zengin_code
  end

  class << self
    def mega_banks
      # 都市銀行
      #   三菱東京UFJ銀行(0005)
      #   みずほ銀行(0001)
      #   三井住友銀行(0009)
      #   りそな銀行(0010)
      #   埼玉りそな銀行(0017)
      #   ゆうちょ銀行(9900)
      self.where(zengin_code: [9900, 5, 1, 9, 10, 17])
    end

    def major_banks
      # 主要銀行
      #   三菱東京UFJ銀行(0005)
      #   みずほ銀行(0001)
      #   三井住友銀行(0009)
      #   りそな銀行(0010)
      #   埼玉りそな銀行(0017)
      #   ゆうちょ銀行(9900)
      #   ジャパンネット銀行(0033)
      #   楽天銀行 (0036)
      #   住信SBIネット銀行(0038)
      #   じぶん銀行（0039)
      self.where(zengin_code: [9900, 5, 1, 9, 10, 17, 33, 36, 38, 39])
    end

    def search_bank_by_name(any_string)
      # TODO 検索文を組み立てる
      # ※カナは促音無しへ正規化、「ギンコウ」除去
    end

    def search_bank_or_branch_by_name(any_string)
      # TODO 検索文を組み立てる
      # ※「支店」「本店」除去
      # ※カナは促音無しへ正規化、 「シテン」「ホンテン」「シユツチヨウシヨ」
    end

    def find_by_zengin_code(zengin_code)
      self.find_by(zengin_code: zengin_code)
    end

    def insert_or_update(zengin_code, bank_name, bank_kana)
      # 追記 or 更新するコードをここへ
      self.transaction do
        old = self.find_by_zengin_code(zengin_code)
        if old
          old.name = bank_name
          old.kana = bank_kana
          old.save
          old
        else
          new = self.new
          new.zengin_code = zengin_code
          new.name        = bank_name
          new.name_kana   = bank_kana
          new.save
          new
        end
      end
    end
  end

  # 正規化
  before_validation :normalize_name
  before_validation :normalize_name_kana

  private

  def normalize_name
    self.name = BankNormalizer.normalize_bank_name(self.name, self.zengin_code)
  end

  def normalize_name_kana
    self.name_kana = BankNormalizer.normalize_bank_name_kana(self.name_kana)
  end
end
