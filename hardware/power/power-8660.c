/*
 * Copyright (c) 2013, The Linux Foundation. All rights reserved.
 * Copyright (C) 2018 The LineageOS Project
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * *    * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of The Linux Foundation nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#define LOG_NIDEBUG 0

#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/un.h>
#include <fcntl.h>
#include <dlfcn.h>
#include <stdlib.h>

#define LOG_TAG "QCOM PowerHAL"
#include <log/log.h>
#include <hardware/hardware.h>
#include <hardware/power.h>

#include "utils.h"
#include "metadata-defs.h"
#include "hint-data.h"
#include "performance.h"
#include "power-common.h"

static int current_power_profile = PROFILE_BALANCED;

static int profile_high_performance[] = {
    CPUS_ONLINE_MIN_2,
};

static int profile_power_save[] = {
    /* Don't do anything for now */
};

#ifdef INTERACTION_BOOST
int get_number_of_profiles()
{
    return 3;
}
#endif

static int set_power_profile(int profile)
{
    int ret = -EINVAL;
    const char *profile_name = NULL;

    if (profile == current_power_profile)
        return 0;

    ALOGV("%s: Profile=%d", __func__, profile);

    if (current_power_profile != PROFILE_BALANCED) {
        undo_hint_action(DEFAULT_PROFILE_HINT_ID);
        ALOGV("%s: Hint undone", __func__);
        current_power_profile = PROFILE_BALANCED;
    }

    if (profile == PROFILE_POWER_SAVE) {
        ret = perform_hint_action(DEFAULT_PROFILE_HINT_ID,
                profile_power_save, ARRAY_SIZE(profile_power_save));
        profile_name = "powersave";

    } else if (profile == PROFILE_HIGH_PERFORMANCE) {
        ret = perform_hint_action(DEFAULT_PROFILE_HINT_ID,
                profile_high_performance, ARRAY_SIZE(profile_high_performance));
        profile_name = "performance";

    } else if (profile == PROFILE_BALANCED) {
        ret = 0;
        profile_name = "balanced";
    }

    if (ret == 0) {
        current_power_profile = profile;
        ALOGD("%s: Set %s mode", __func__, profile_name);
    }
    return ret;
}

int power_hint_override(power_hint_t hint, void *data)
{
    if (hint == POWER_HINT_SET_PROFILE) {
        if (set_power_profile(*(int32_t *)data) < 0)
            ALOGE("Setting power profile failed. perfd not started?");
        return HINT_HANDLED;
    }

    // Skip other hints in high/low power modes
    if (current_power_profile == PROFILE_POWER_SAVE ||
            current_power_profile == PROFILE_HIGH_PERFORMANCE) {
        return HINT_HANDLED;
    }

    return HINT_NONE;
}

#ifdef SET_INTERACTIVE_EXT
static int last_state = -1;

/* connects to the touchscreen socket */
static void send_ts_socket(char *send_data) {
    struct sockaddr_un unaddr;
    int ts_fd, len;

    ts_fd = socket(AF_UNIX, SOCK_STREAM, 0);

    if (ts_fd >= 0) {
        unaddr.sun_family = AF_UNIX;
        strcpy(unaddr.sun_path, "/dev/socket/tsdriver");
        len = strlen(unaddr.sun_path) + sizeof(unaddr.sun_family);
        if (connect(ts_fd, (struct sockaddr *)&unaddr, len) >= 0) {
            send(ts_fd, send_data, sizeof(*send_data), 0);
        }
        close(ts_fd);
    }
}

void power_set_interactive_ext(int on)
{
    if (last_state == on)
        return;

    send_ts_socket((on ? "O" : "C"));

    last_state = on;
}
#endif
