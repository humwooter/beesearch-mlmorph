import sys
import re

def calculate_window_size(tps_file_path):
    x_coords = []
    y_coords = []
    
    with open(tps_file_path, 'r') as file:
        for line in file:
            match = re.match(r'^(\d+\.\d+)\s+(\d+\.\d+)$', line.strip())
            if match:
                x, y = map(float, match.groups())
                x_coords.append(x)
                y_coords.append(y)
    
    if x_coords and y_coords:
        min_x = min(x_coords)
        max_x = max(x_coords)
        min_y = min(y_coords)
        max_y = max(y_coords)
        
        width = max_x - min_x
        height = max_y - min_y
        
        buffer_percent = 0.20
        window_size = max(width, height) * (1 + buffer_percent)
        return round(window_size)
    else:
        return None

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python calculate_window_size.py <tps_file_path>")
        sys.exit(1)
    
    tps_path = sys.argv[1]
    size = calculate_window_size(tps_path)
    if size is not None:
        print(size)
    else:
        print("No valid coordinates found.")