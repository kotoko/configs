# Update system.
class update_system {
	# Run multiple times just for sure. Sometimes xbps
	# wants to be updated and then only xbps updates.
	# For updating whole system another pass is required.
	update_system::update { '1': }
	update_system::update { '2': }
	update_system::update { '3': }

	Update_system::Update['1'] ->
	Update_system::Update['2'] ->
	Update_system::Update['3']
}
