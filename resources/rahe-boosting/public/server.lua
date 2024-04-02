function generateLicensePlate()
    local newPlate = exports["usa_carshop"]:generate_random_number_plate()
    return newPlate
end

function isPictureUrlValid(url)
    if url:len() > 100 or url:find("[&<>\"]") then
        return false
    end

    local host = url:match("^%a+://([^/]+)")
    if host == svConfig.recommendedUploadWebsite then
        return true
    end

    for _, allowedHost in ipairs(svConfig.allowedImageHosts) do
        if host == allowedHost then
            return true
        end
    end

    return false
end

function deleteDropOffVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
end