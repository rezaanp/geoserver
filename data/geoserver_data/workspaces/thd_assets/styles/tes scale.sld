<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
    xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
    xmlns="http://www.opengis.net/sld"
    xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <NamedLayer>
    <Name>polygon_style_no_scale</Name>
    <UserStyle>
      <Title>Polygon Style - No Scale Limit</Title>
      <FeatureTypeStyle>

        <Rule>
          <Title>Default Polygon Style</Title>

          <PolygonSymbolizer>
            <Fill>
              <CssParameter name="fill">#4CAF50</CssParameter>
              <CssParameter name="fill-opacity">0.5</CssParameter>
            </Fill>

            <Stroke>
              <CssParameter name="stroke">#2E7D32</CssParameter>
              <CssParameter name="stroke-width">1.5</CssParameter>
            </Stroke>
          </PolygonSymbolizer>

        </Rule>

      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>

</StyledLayerDescriptor>