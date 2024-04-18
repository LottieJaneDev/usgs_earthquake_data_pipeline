{% macro get_network_names(network) %}
    case
        when {{ network }} = 'ak' then 'Alaska Geophysical Network (AK)'
        when {{ network }} = 'at' then 'National Tsunami Warning Center Alaska Seismic Network (AT)'
        when {{ network }} = 'av' then 'Alaska Volcano Observatory (AV)'
        when {{ network }} = 'ci' then 'Southern California Seismic Network (SCSN) (CI)'
        when {{ network }} = 'hv' then 'Hawaiian Volcano Observatory Network (HV)'
        when {{ network }} = 'mb' then 'Montana Regional Seismic Network (MB)'
        when {{ network }} = 'nc' then 'USGS Northern California Seismic Network (NC)'
        when {{ network }} = 'nn' then 'Nevada Seismic Network (NN)'
        when {{ network }} = 'nm' then 'Cooperative New Madrid Seismic Network (NM)'
        when {{ network }} = 'ok' then 'Oklahoma Seismic Network (OK)'
        when {{ network }} = 'pgc' then 'Unknown'
        when {{ network }} = 'pr' then 'Puerto Rico Seismic Network & Puerto Rico Strong Motion Program (PR)'
        when {{ network }} = 'se' then 'Southeastern Appalachian Cooperative Seismic Network (SE)'
        when {{ network }} = 'tx' then 'Texas Seismological Network (TX)'
        when {{ network }} = 'uu' then 'University of Utah Regional Seismic Network (UU)'
        when {{ network }} = 'us' then 'United States National Seismic Network (US)'
        when {{ network }} = 'uw' then 'Pacific Northwest Seismic Network - University of Washington (UW)'
        when {{ network }} = 'zamg' then 'Zentralanstalt für Meterologie und Geodynamik (ZAMG)'
        else 'Unknown'
    end
{% endmacro %}
