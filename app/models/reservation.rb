class Reservation < ActiveRecord::Base

  require 'pry'

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validate :host_is_not_guest
  validate :available_dates
  validate :valid_dates

  validates :checkin, :checkout, presence: true

  accepts_nested_attributes_for :listing


       # knows about its duration based on checkin and checkout dates (FAILED - 14)

       # knows about its total price (FAILED - 15)

  def duration
    checkin - checkout
  end

  def total_price
  end

  private

  def valid_dates
    if self.checkin && self.checkout
      if checkin > checkout || checkin == checkout
        errors.add(:reservation, "Checkin cannot be after Checkout dates.")
      end
    end
  end

  def available_dates
    if self.checkin && self.checkout
      listing.reservations.each do | reservation |
        if (reservation.checkin <= checkout ) && (checkin <= reservation.checkout)
          errors.add(:reservation, "Not available these dates.")
        end
      end
    end

  end

  def host_is_not_guest
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't rent out your own place silly.")
    end
  end

end
