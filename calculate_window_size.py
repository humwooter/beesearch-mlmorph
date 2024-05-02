def calculate_window_size(tps_file_path):
    import re
    
    # Initialize lists to store all x and y coordinates
    x_coords = []
    y_coords = []
    
    # Read the TPS file
    with open(tps_file_path, 'r') as file:
        for line in file:
            # Find lines with coordinates using regular expression
            match = re.match(r'^(\d+\.\d+)\s+(\d+\.\d+)$', line.strip())
            if match:
                x, y = map(float, match.groups())
                x_coords.append(x)
                y_coords.append(y)
    
    # Calculate the bounding box dimensions
    if x_coords and y_coords:
        min_x = min(x_coords)
        max_x = max(x_coords)
        min_y = min(y_coords)
        max_y = max(y_coords)
        
        width = max_x - min_x
        height = max_y - min_y
        
        # Suggest a window size with a 20% buffer
        buffer_percent = 0.20
        window_size = max(width, height) * (1 + buffer_percent)
        return round(window_size)
    else:
        return None  # Return None if no coordinates were found

# Example usage
tps_path = 'path_to_your_tps_file.tps'
ideal_window_size = calculate_window_size(tps_path)
print(f"Ideal window size: {ideal_window_size} pixels")