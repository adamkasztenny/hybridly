class ReservationConfirmationService
  def self.create_qr_code(reservation)
    confirmation_url = "/reservations/#{reservation.verification_code}/verify"
    RQRCode::QRCode.new(confirmation_url).as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true,
    )
  end
end
