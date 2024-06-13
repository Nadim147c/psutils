param([string]$text)

# Load System.Drawing assembly
Add-Type -AssemblyName System.Drawing

# Set text and font properties
$text = "Hello, World!"
$font = New-Object System.Drawing.Font("Arial", 24)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Black)

# Create a bitmap to draw on
$image = New-Object System.Drawing.Bitmap(200, 100)
$graphics = [System.Drawing.Graphics]::FromImage($image)

# Draw the text on the bitmap
$graphics.DrawString($text, $font, $brush, 0, 0)

# Save the bitmap to the clipboard
$clipboardStream = New-Object System.IO.MemoryStream
$image.Save($clipboardStream, [System.Drawing.Imaging.ImageFormat]::Png)
# [System.]
# [System.Windows.Forms.Clipboard]::SetData("PNG", $clipboardStream.GetBuffer())
Set-Clipboard -Value $clipboardStream.GetBuffer()

# Clean up
$graphics.Dispose()
$clipboardStream.Dispose()

