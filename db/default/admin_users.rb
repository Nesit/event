admin = AdminUser.where(email: "admin@example.com").first
admin ||= AdminUser.new
admin.password = "productionadminpassword"
admin.email = 'admin@example.com'
admin.save!
