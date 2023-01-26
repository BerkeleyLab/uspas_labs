def calc_dds(num_dds, den_dds, dwh=20, dwl=12):
    """
    Calculate dds registers from rational frequency setting

    :param int num_dds: numerator of fractional frequency
    :param int den_dds: denominator of fractional frequency
    :param int dwh:     data width of major resolution register
    :param int dwl:     data width of minor resolution register
    :return int:        major resolution, minor resolution, modulor registers
    """
    m, modulo = divmod((1 << dwl), den_dds)
    r = (1 << dwh) * num_dds
    phase_step_h = int(r / den_dds)
    phase_step_l = int(r % den_dds * m)
    return phase_step_h, phase_step_l, modulo


def reg2freq(ph, pl, modulo, fclk, dwh=20, dwl=12):
    """
    Calculate frequency using dds registers

    :param int ph:      major resolution register
    :param int pl:      minor resolution register
    :param int modulo:  modulo register
    :param int fclk:    clock frequency in Hz
    :param int dwh:     data width of major resolution register
    :param int dwl:     data width of minor resolution register
    :return int:        DDS frequency in Hz
    """
    # step_mod = modulo * pl / 2**dwl
    resol = fclk / (2**dwh) / (2**dwl - modulo)
    maj_resol = resol*(2**dwl-modulo)
    print(f'major resolution:  {maj_resol:.3f} Hz')
    print(f'minor resolution:  {resol:.3f} Hz')
    print(f'modulo resolution: {resol/2**dwl * pl:.3f} Hz')
    freq = (ph * (2**dwl-modulo) + pl) * resol
    return freq
