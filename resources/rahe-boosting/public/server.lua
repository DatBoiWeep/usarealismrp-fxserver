function generateLicensePlate()
    local newPlate = exports["usa_carshop"]:generate_random_number_plate()
    return newPlate
end

function deleteDropOffVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
end